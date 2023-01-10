import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "starsTable", "starsGraphs" ]

  afterSubmit(event) {
    if(event.detail.success) {
      this.starsTableTarget.reload()
      this.starsGraphsTarget.reload()
    }
  }
}
