/** @type {import('next').NextConfig} */
const nextConfig = {
  async redirects() {
    return [
      {
        source: '/',
        destination: '/rpcs',
        permanent: false,
      },
    ];
  },
};

module.exports = nextConfig;
