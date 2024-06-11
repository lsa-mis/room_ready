import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["access", "noaccess"];

  connect() {
    const isBothOptionsEmpty = !this.accessTarget.checked && !this.noaccessTarget.checked;
    if(!isBothOptionsEmpty){
      this.render()
    }
  }

  renderNoAccessReasonField(){
    this.render();
  }

  render(){
    const noReasonField =  document.getElementById("no-reason");
    const roverHasAccess = this.accessTarget.checked;
    if (!roverHasAccess){
     noReasonField.style.display = "block";
    } else {
      noReasonField.style.display = "none";
    }
  }
}
