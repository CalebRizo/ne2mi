const AWS = require('aws-sdk')
const uuid = require('uuid/v1');

AWS.config.update({region:'us-east-1'});
const dynamodb = new AWS.DynamoDB();

exports.handler = (event, context, callback) => {
    console.log(event.requestContext.httpMethod)
    if (event.requestContext.httpMethod === 'POST') {
        const hist = {
            Item: {
                "gait": {
                    S: uuid()
                }, 
                "data": {
                    S: event.body
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
                    S: event.body
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
            else     {       
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
