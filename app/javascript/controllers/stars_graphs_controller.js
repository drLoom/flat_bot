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

    const series = data.reduce(((grouped, row) => {
      grouped[row.object_id] ||= [];
      grouped[row.object_id].push(row);
      return grouped;
    }), {});

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
      yAxis: {
        title: {
          text: '$м²'
        },
        min: 0
      },
      tooltip: {
        headerFormat: '<b>{series.name}</b><br>',
        pointFormat: '{point.x:%Y %e. %b}: {point.y:.1f} $м²'
      },
      plotOptions: {
        series: {
          marker: {
            enabled: false,
          }
        }
      },
      colors: COLORS,
      series: Object.keys(series).map((object_id, i) => {
        return {
          name: `${object_id}`,
          lineWidth: 1.5,
          data: series[object_id].map(row => {
            return [row.date.getTime(), Number(parseFloat(row.meter_price).toFixed(1))]
          }),
        }
      })
    })
  }
};
