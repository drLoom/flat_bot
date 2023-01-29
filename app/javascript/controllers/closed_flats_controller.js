import Highcharts from 'highcharts';
import ChartDataController from 'controllers/chart_data_controller';
import { COLORS } from 'settings/colors';


export default class extends ChartDataController {
  COLORS = ['#131414', '#17a3a3', '#f0074d', '#1923e3', '#23752e', '#c4320e', '#dc85ed'];

  drawChart(data) {
    data = data.map(el => {
      el.date = new Date(el.date);
      return el
    });

    const dateFormat = '%e-%m-%y';

    Highcharts.chart(this.element, {
      chart: {
        type: 'spline'
      },
      title: {
        text: 'Цена $м² выбранных квартир'
      },
      xAxis: {
        type: 'datetime',
        dateTimeLabelFormats: {
          millisecond: dateFormat,
          second: dateFormat,
          minute: dateFormat,
          hour: dateFormat,
          day: dateFormat,
          week: dateFormat,
          month: dateFormat,
          year: dateFormat
        },
        title: {
          text: 'Датa'
        }
      },
      yAxis: [
        {
          title: {
            text: '$м²'
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
          max: 5000,
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
        series: {
          marker: {
            enabled: false,
          }
        }
      },
      colors: COLORS,
      series: [{
        name: '$м²',
        type: 'spline',
        color: COLORS.ORANGE,
        zIndex: 1,
        marker: {
          symbol: 'round'
        },
        data: data.map(el => [el.date.getTime(), Number(parseFloat(el.meter_price).toFixed(1))])
      },
      {
        type: 'column',
        yAxis: 1,
        zIndex: 0,
        name: 'Кол-во квартир',
        data: data.map(el => [el.date.getTime(), el.cnt]),
        color: COLORS.BLUE
      }]
    })
  }
};
