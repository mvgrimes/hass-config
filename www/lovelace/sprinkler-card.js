class SprinklerCard extends HTMLElement {
  set hass(hass) {
    if (!this.content) {
      const card = document.createElement('ha-card');
      card.header = this.config.title;
      this.content = document.createElement('div');
      // this.content.style.padding = '0 16px 16px';
      card.appendChild(this.content);
      this.appendChild(card);
    }

    const entityId = this.config.entity;
    const state = hass.states[entityId];
    const stateStr = state ? state.state : 'unavailable';
    const queued = state.attributes.queued;
    const duration = state.attributes.duration;
    const name = state.attributes.friendly_name;

    console.log(state);
    this.content.innerHTML = `
      <small>${queued ? '(queued for ${duration} minutes)' : 'not queued'}</small>
    `;
  }

  setConfig(config) {
    if (!config.entity) {
      throw new Error('You need to define an entity');
    }
    this.config = config;
  }

  // The height of your card. Home Assistant uses this to automatically
  // distribute all cards over the available columns.
  getCardSize() {
    return 1;
  }
}

customElements.define('sprinkler-card', SprinklerCard);
