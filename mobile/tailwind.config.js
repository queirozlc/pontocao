/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./app/**/*.{ts,tsx}', './components/**/*.{ts,tsx}'],
  presets: [require('nativewind/preset')],
  theme: {
    extend: {
      colors: {
        brand: {
          500: '#FF407D'
        }
      },
      fontFamily: {
        'sans-regular': ['Inter_400Regular'],
        'sans-medium': ['Inter_500Medium'],
        'sans-semibold': ['Inter_600SemiBold'],
        'sans-bold': ['Inter_700Bold'],
        'title-medium': ['Cabinet_Grotestk_500Medium'],
        'title-bold': ['Cabinet_Grotestk_700Bold']
      }
    }
  },
  plugins: []
}
