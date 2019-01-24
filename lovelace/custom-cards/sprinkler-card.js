    // const entityId = this.config.entity;
    // const state = hass.states[entityId];
    // const stateStr = state ? state.state : 'unavailable';
    // const queued = state.attributes.queued;
    // const duration = state.attributes.duration;
    // const name = state.attributes.friendly_name;

class SprinklerZoneRow extends Polymer.Element {
  static get template() {
    return Polymer.html`
    <style>
      hui-generic-entity-row {
        margin: var(--ha-themed-slider-margin, initial);
      }
      .second-line {
        width: 80%;
        padding-left: 5em;
      }
    </style>
    <hui-generic-entity-row config="[[_config]]" hass="[[_hass]]">
      {{value}}
    </hui-generic-entity-row>
    <div class="second-line">
      <template is='dom-if' if='{{queued}}'>
        In queue and scheduled for {{duration}} minutes
      </template>
      <template is='dom-if' if='{{!queued}}'>
        Not queued
      </template>
    </div>
    `;
  }

  static get properties() {
    return {
      _hass: Object,
      _config: Object,
      isOn: { type: Boolean },
      stateObj: { type: Object, value: null },
      // attribute: { type: String, value: 'brightness' },
      value: Number,
    };
  }

  setConfig(config)
  {
    this._config = config;
    // if('hide_control' in config && config.hide_control)
    //   this.hideControl = true;
    // if('break_slider' in config && config.break_slider)
    //   this.breakSlider = true;
    // if('hide_when_off' in config && config.hide_when_off)
    //   this.hideWhenOff = true;
  }

  // updateSliders()
  // {
  //   this.showTop = false;
  //   this.showBottom = false;
  //   if(!(this.attribute in this.stateObj.attributes)) {
  //     if(!('supported_features' in this.stateObj.attributes) ||
  //       !(this.stateObj.attributes['supported_features'] & 1)) {
  //         return;
  //     }
  //   }
  //   if(!(this.hideWhenOff && !this.isOn)) {
  //     if(this.breakSlider)
  //       this.showBottom = true;
  //     else
  //       this.showTop = true;
  //   }
  // }

  set hass(hass) {
    this._hass = hass;
    this.stateObj = this._config.entity in hass.states ? hass.states[this._config.entity] : null;

    if(this.stateObj) {
      if(this.stateObj.state === 'True') {
        this.value = 'On';
        this.queued = this.stateObj.attributes.queued;
        this.duration = this.stateObj.attributes.duration;
      } else {
        this.value = 'Off';
        this.queued = this.stateObj.attributes.queued;
        this.duration = this.stateObj.attributes.duration;
      }
      // this.updateSliders();
    }
  }

  // selectedValue(ev) {
  //   const value = parseInt(this.value, 10);
  //   const param = {entity_id: this.stateObj.entity_id };
  //   if(Number.isNaN(value)) return;
  //   if(value === 0) {
  //     this._hass.callService('light', 'turn_off', param);
  //   } else {
  //     param[this.attribute] = value;
  //     this._hass.callService('light', 'turn_on', param);
  //   }
  // }

  // stopPropagation(ev) {
  //   ev.stopPropagation();
  // }
}

customElements.define('sprinkler-zone-row', SprinklerZoneRow);
