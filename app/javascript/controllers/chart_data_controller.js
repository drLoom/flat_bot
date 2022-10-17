import { Controller } from "@hotwired/stimulus"

export default class ChartDataController extends Controller {
  static values = { url: String };

  connect() {
    fetch(this.urlValue, { headers: {'Accept': 'application/json'}})
      .then(response => response.json()).then((data) => this.drawChart(data));
  }

  drawChart(data) {
    throw 'Not implemented';
  }
}
