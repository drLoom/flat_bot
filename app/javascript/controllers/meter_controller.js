import { Controller } from "@hotwired/stimulus"

// import * as Highcharts from 'highcharts';
import Highcharts from 'highcharts';

// import Exporting from 'highcharts/modules/exporting';
// Exporting(Highcharts);

export default class extends Controller {
  static targets = ["stats"];

  connect() {
    const data = JSON.parse(this.statsTarget.textContent);

    Highcharts.chart(this.element, {
      chart: {
        type: 'spline'
      },
      title: {
        text: 'м² $'
      },
      xAxis: {
        categories: Object.keys(data),
        accessibility: {
          description: 'Date'
        }
      },
      yAxis: {
        title: {
          text: 'м²'
        },
        labels: {
          formatter: function () {
            return this.value + '$';
          }
        }
      },
      tooltip: {
        crosshairs: true,
        shared: true
      },
      plotOptions: {
        spline: {
          marker: {
            radius: 4,
            lineColor: '#666666',
            lineWidth: 1
          }
        }
      },
      series: [{
        name: 'м²',
        marker: {
          symbol: 'square'
        },
        data: Object.values(data).map(x => Math.round(Number(x), 2))
      }]
    });
  }
}
