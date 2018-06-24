const AWS = require('aws-sdk')
const uuid = require('uuid/v1');
var algorithmia = require("algorithmia");
var client = algorithmia(process.env.ALGO_KEY);

AWS.config.update({region:'us-east-1'});
const dynamodb = new AWS.DynamoDB();

const fourier = (arr) => new Promise((resolve, reject) => {
    var input = [arr,1,1];
    client
        .algo("TimeSeries/FourierFilter/0.1.1")
        .pipe(input)
        .then(function(response) {
            console.log(response.get());
            resolve(response.get());
        });
});

exports.handler = (event, context, callback) => {
    if (event.requestContext.httpMethod === 'POST') {
        const parsedData = JSON.parse(event.body);

        Promise.all([fourier(parsedData.x), fourier(parsedData.y), fourier(parsedData.z)]).then(([x, y , z]) => {

            const newBody = JSON.stringify({
                x, y ,z , time: parsedData.time
            })

            const hist = {
                Item: {
                    "gait": {
                        S: uuid()
                    }, 
                    "data": {
                        S: newBody
                    }
                }, 
                ReturnConsumedCapacity: "TOTAL", 
                TableName: "ne2mi"
            };
            const last = {
                Item: {
                    "gait": {
                        S: 'last'
                    }, 
                    "data": {
                        S: newBody
                    }
                }, 
                ReturnConsumedCapacity: "TOTAL", 
                TableName: "ne2mi"
            };
            const putItem = (params) => new Promise((resolve,reject) => {
                dynamodb.putItem(params, function(err, data) {
                    if (err) {
                        console.log(err, err.stack);
    
                        reject(err.message)
                    } // an error occurred
                    else {
                        resolve()
                    }
                });
            });
    
            Promise.all([putItem(hist), putItem(last)]).then(() => {
                callback(null, {
                    "statusCode": "200",
                    "body": "{\"message\":\"ok\"}"
                });
            }).catch((err) => {
                callback(null, {
                    "statusCode": "500",
                    "body": err
                });
            })
        })

    }
    else if (event.requestContext.httpMethod === 'GET') {
        const params = {
            Key: {
             "gait": {
               S: "last"
              }, 
            }, 
            TableName: "ne2mi"
        };
        dynamodb.getItem(params, function(err, data) {
            if (err) {
                callback(null, {
                    "statusCode": "500",
                    "body": err.message
                });
            }
            else     {console.log(data);           // successful response
            callback(null, {
                "statusCode": "200",
                "headers": {
                    "Access-Control-Allow-Origin": "*"
                },
                "body":  data.Item.data.S
            });
        }
          });
    } else {
        callback(null, {
            "statusCode": "400",
            "body": JSON.stringify({ message: 'unsuported method'})
        });
    }
};
