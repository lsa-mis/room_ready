import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["access", "noaccess"];

  noReasonField =  document.getElementById("no-reason").style;

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
    const roverHasAccess = this.accessTarget.checked;
    if (!roverHasAccess){
      this.noReasonField.display = "block";
    } else {
      this.noReasonField.display = "none";
    }
  }
}
