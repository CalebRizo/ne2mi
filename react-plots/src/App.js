import React, { Component } from 'react'
import Plot from 'react-plotly.js'

import logo from './logo.svg'
import './App.css'
import DATA from './plot_mock_data'

const trace = {
  x: DATA.x,
  y: DATA.y,
  legendgroup: 'opennesstoexperience',
  marker: {color: 'rgb(31, 119, 180)'},
  mode: 'lines',
  name: 'opennesstoexperience',
  showlegend: false,
  type: 'scatter',
  xaxis: 'x1',
  yaxis: 'y1'
};
const data = [trace];
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
    domain: [0.35, 1],
    position: 0.0
  },
};

class App extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Welcome to Ne<sup>2</sup>mi!</h1>
        </header>
        <Plot
          data={data}
          layout={layout}
        />
      </div>
    );
  }
}

export default App;
