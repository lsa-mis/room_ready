import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "hide_section", "more_button", "less_button" ]
  connect() {
    console.log("Hiding Element controller connected")
  }
  showElement() {
    console.log("Hit showElement")
    this.hide_sectionTarget.classList.remove("d-none")
    this.hide_sectionTarget.classList.add("d-block")
    this.more_buttonTarget.classList.add("d-none")
    this.more_buttonTarget.classList.remove("d-block")
    this.less_buttonTarget.classList.remove("d-none")
    this.less_buttonTarget.classList.add("d-block")
  }

  hideElement() {
    this.hide_sectionTarget.classList.add("d-none")
    this.hide_sectionTarget.classList.remove("d-block")
    this.more_buttonTarget.classList.remove("d-none")
    this.more_buttonTarget.classList.add("d-block")
    this.less_buttonTarget.classList.add("d-none")
    this.less_buttonTarget.classList.remove("d-block")
  }

}
