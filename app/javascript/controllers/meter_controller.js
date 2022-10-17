import Highcharts from 'highcharts';
import ChartDataController from './chart_data_controller';

export default class extends ChartDataController {
  drawChart(data) {
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
          max: 50000,
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
            lineWidth: 1
          }
        }
      },
      series: [
        {
          name: 'м²',
          type: 'spline',
          color: '#FC6A03',
          zIndex: 1,
          marker: {
            symbol: 'square'
          },
          data: data.map(el => Math.round(Number(el.avg)))
        },
        {
          type: 'column',
          yAxis: 1,
          zIndex: 0,
          name: 'Кол-во квартир',
          data: data.map(el => el.count),
          color: '#028A0F'
        }
      ]
    });
  }
}
