import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['form']
  
  connect () {
    console.log("connect autosubmit")
  }
  submitForm() {
    console.log("here")
    Turbo.navigator.submitForm(this.formTarget)
  }
  
  search() {
    console.log("search")
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, 200)
  }
}
