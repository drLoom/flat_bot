import Highcharts from 'highcharts';
import ChartDataController from 'controllers/chart_data_controller';

export default class extends ChartDataController {
  COLORS = ['#131414', '#17a3a3', '#f0074d', '#1923e3', '#23752e', '#c4320e','#dc85ed'];

  drawChart(data) {
    const series = data.reduce(((grouped, row) => {
      grouped[row.rooms] ||= [];
      grouped[row.rooms].push(row);
      return grouped;
    }), {});

    Highcharts.chart(this.element, {
      title: {
        text: 'м² $* '
      },
      xAxis: {
        categories: data.map(el => el.date),
        accessibility: {
          description: 'Date'
        }
      },
      yAxis: [
        { // Secondary yAxis
          title: {
            text: 'Количество квартир',
            style: {
              color: Highcharts.getOptions().colors[0]
            }
          },
          max: 25000,
          labels: {
            format: '{value}',
            style: {
              color: Highcharts.getOptions().colors[0]
            }
          },
        },
        {
          title: {
            text: '<b>м² $</b>'
          },
          labels: {
            formatter: function () {
              return this.value + '$';
            }
          },
          opposite: true
        }
        ],
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
      series: Object.keys(series).map((rooms, i) => {
        return [{
            name: rooms,
            type: 'spline',
            yAxis: 1,
            zIndex: 1,
            color: this.COLORS[i],
            data: series[rooms].map(row => Math.round(Number(row.meter_price)))
          },
          {
            type: 'column',
            color: this.COLORS[i],
            zIndex: 0,
            name: '',
            data: series[rooms].map(row => Math.round(Number(row.cnt)))
          }
        ];
      }).flat()
    });
  }
}
