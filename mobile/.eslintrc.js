module.exports = {
  root: true,
  extends: ['universe/native', 'plugin:tailwindcss/recommended'],
  rules: {
    // Ensures props and state inside functions are always up-to-date
    'react-hooks/exhaustive-deps': 'warn',
    'no-undef': 'off'
  }
}
