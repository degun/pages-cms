/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    serverActions: {
      bodySizeLimit: "100mb"
    }
  },
  output: "standalone"
};

export default nextConfig;