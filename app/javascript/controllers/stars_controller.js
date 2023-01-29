import { Controller } from "@hotwired/stimulus"
import Highcharts from 'highcharts';

export default class extends Controller {
  static targets = [ "starsTable", "starsGraphs" ]

  afterSubmit(event) {
    if(event.detail.success) {
      this.starsTableTarget.reload()
      this.starsGraphsTarget.reload()
    }
  }

  chart() {
    if(this._chart == undefined) {
      let chartContainer = document.querySelector("div[data-controller='stars-graphs']");
      this._chart = Highcharts.charts[chartContainer.getAttribute('data-highcharts-chart')];
    }
    return this._chart;
  }

  rowHover(event) {
    if (this.chart()) {
      let objectId = event.currentTarget.getElementsByTagName('td')[1].textContent;
      this.chart().series.find(s => s.name === objectId).data[0].setState('hover')
    }
  }
}
