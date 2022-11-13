import Highcharts from 'highcharts';
import ChartDataController from 'controllers/chart_data_controller';

export default class extends ChartDataController {

  drawChart(data) {
    Highcharts.chart(this.element, {
      chart: {
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false,
        type: 'pie'
      },
      title: {
        text: 'По количеству комнат'
      },
      tooltip: {
        pointFormat: '<b>{point.percentage:.1f}%</b>'
      },
      accessibility: {
        point: {
          valueSuffix: '%'
        }
      },
      plotOptions: {
        pie: {
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: true,
            format: '<b>{point.name}</b>: {point.percentage:.1f} %'
          }
        }
      },
      series: [{
        name: '',
        colorByPoint: true,
        data: Object.keys(data).map(k => {
          return {
            name: Number(k),
            y: data[k],
            sliced: true,
            selected: false
          };
        })
      }]
    });
  }
}
