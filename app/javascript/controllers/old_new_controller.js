import Highcharts from 'highcharts';
import ChartDataController from 'controllers/chart_data_controller';
import { COLORS } from '../settings/colors';


export default class extends ChartDataController {
  drawChart(data) {
    Highcharts.chart(this.element, {
      title: {
        text: 'Новые и снятые объявления'
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
            text: 'Количество квартир'
          },
          labels: {
            formatter: function () {
              return this.value;
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
          name: 'Снятые объявления',
          type: 'spline',
          marker: {
            symbol: 'round'
          },
          color: COLORS.ORANGE,
          data: data.map(el => el.old_cnt)
        },
        {
          type: 'spline',
          name: 'Новые обявления',
          color: COLORS.BLUE,
          data: data.map(el => el.new_cnt)
        }
      ]
    });
  }
}
