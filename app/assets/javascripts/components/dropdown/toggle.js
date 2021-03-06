Vue.component('dropdown-toggle', {
  computed: {
    isVisible: {
      get() {
        return this.$parent.isVisible;
      },
      set(newValue) {
        App.bus.$emit("closeDropdowns");
        this.$parent.isVisible = newValue;
      }
    }
  },
  template: `
    <a class="dropdown-toggle" @click.stop="isVisible = !isVisible">
      <slot></slot>
    </a>
  `
});
