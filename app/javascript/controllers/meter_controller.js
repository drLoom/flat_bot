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
      title: {
        text: 'м² $'
      },
      xAxis: {
        categories: data.map(el => el.date),
        accessibility: {
          description: 'Date'
        }
      },
      yAxis: [
        {
          title: {
            text: 'м²'
          },
          labels: {
            formatter: function () {
              return this.value + '$';
            }
          }
        },
        { // Secondary yAxis
          title: {
            text: 'Кол-во квартир',
            style: {
              color: Highcharts.getOptions().colors[0]
            }
          },
          labels: {
            format: '{value}',
            style: {
              color: Highcharts.getOptions().colors[0]
            }
          },
          opposite: true
        }],
      tooltip: {
        crosshairs: false,
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
      series: [
        {
          name: 'м²',
          type: 'spline',
          marker: {
            symbol: 'square'
          },
          data: data.map(el => Math.round(Number(el.avg)))
        },
        {
          type: 'column',
          yAxis: 1,
          name: 'Кол-во квартир',
          data: data.map(el => el.count)
        }
      ]
    });
  }
}
