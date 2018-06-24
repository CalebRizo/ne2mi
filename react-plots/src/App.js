import React, { Component } from 'react'
import Plot from 'react-plotly.js'
import axios from 'axios'

import logo from './logo.svg'
import './App.css'
import BASE_DATA from './utils/ne2mi-base-data'

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      step: 0,
      xAxis: [],
      yAxis: [],
      zAxis: [],
      t: [],
    }
  }

  componentWillMount() {
    this._fetchNe2miData()
  }

  _fetchNe2miData() {
    axios.get('https://08oio458y8.execute-api.us-east-1.amazonaws.com/dev')
    .then(resp  => {
      const { x, y, z, time } = resp.data
      const plus2 = x => x + 2
      const xAxis = x.map(plus2)
      const yAxis = y.map(plus2)
      const zAxis = z.map(plus2)
      const length = x.length
      const t = [...Array(length).keys()].map(x => x * time)

      console.log({zAxis})
      console.log({yAxis})
      console.log({xAxis})

      this.setState({ xAxis, yAxis, zAxis, t })
    })
  }

  render() {
    const layout = {
      barmode: 'overlay',
      hovermode: 'closest',
      legend: {traceorder: 'reversed'},
      title: 'Distplot with Normal Distribution',
      xaxis1: {
        anchor: 'y1',
        domain: [0.0, 1.0],
        zeroline: false
      },
      yaxis1: {
        anchor: 'x1',
        domain: [0.1, 3],
        position: 0.0
      },
    };
    const layoutX = Object.assign({}, layout)
    layoutX.title = 'X-axial Force'
    const layoutY = Object.assign({}, layout)
    layoutY.title = 'Y-axial Force'
    const layoutZ = Object.assign({}, layout)
    layoutZ.title = 'Z-axial Force'
    
    const baseX = {
      x: this.state.t,
      y: BASE_DATA.xBase,
      legendgroup: 'opennesstoexperience',
      marker: {color: 'rgb(204, 16, 38)'},
      mode: 'lines',
      name: 'opennesstoexperience',
      showlegend: false,
      type: 'scatter',
      xaxis: 'x1',
      yaxis: 'y1'
    }
    const traceX = {
      x: this.state.t,
      y: this.state.xAxis,
      legendgroup: 'opennesstoexperience',
      marker: {color: 'rgb(31, 119, 180)'},
      mode: 'lines',
      name: 'opennesstoexperience',
      showlegend: false,
      type: 'scatter',
      xaxis: 'x1',
      yaxis: 'y1'
    }
    const dataX = [baseX, traceX];

    const baseY = {
      x: this.state.t,
      y: BASE_DATA.yBase,
      legendgroup: 'opennesstoexperience',
      marker: {color: 'rgb(204, 16, 38)'},
      mode: 'lines',
      name: 'opennesstoexperience',
      showlegend: false,
      type: 'scatter',
      xaxis: 'x1',
      yaxis: 'y1'
    }
    const traceY = {
      x: this.state.t,
      y: this.state.yAxis,
      legendgroup: 'opennesstoexperience',
      marker: {color: 'rgb(31, 119, 180)'},
      mode: 'lines',
      name: 'opennesstoexperience',
      showlegend: false,
      type: 'scatter',
      xaxis: 'x1',
      yaxis: 'y1'
    };
    const dataY = [baseY, traceY];

    const baseZ = {
      x: this.state.t,
      y: BASE_DATA.zBase,
      legendgroup: 'opennesstoexperience',
      marker: {color: 'rgb(204, 16, 38)'},
      mode: 'lines',
      name: 'opennesstoexperience',
      showlegend: false,
      type: 'scatter',
      xaxis: 'x1',
      yaxis: 'y1'
    }
    const traceZ = {
      x: this.state.t,
      y: this.state.zAxis,
      legendgroup: 'opennesstoexperience',
      marker: {color: 'rgb(31, 119, 180)'},
      mode: 'lines',
      name: 'opennesstoexperience',
      showlegend: false,
      type: 'scatter',
      xaxis: 'x1',
      yaxis: 'y1'
    };
    const dataZ = [baseZ, traceZ];
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Welcome to Ne<sup>2</sup>mi!</h1>
        </header>
        <Plot
          data={dataX}
          layout={layoutX}
        />
        <Plot
          data={dataY}
          layout={layoutY}
        />
        <Plot
          data={dataZ}
          layout={layoutZ}
        />
      </div>
    );
  }
}

export default App;
