module.exports = new Proxy(
  {},
  {
    get: function getter() {
      return () => ({
        className: 'geist',
        variable: '--font-geist-sans',
        style: { fontFamily: 'geist-sans' },
      })
    },
  }
)