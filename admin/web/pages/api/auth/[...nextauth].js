import NextAuth from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";
import { checkAuth } from '/helper/basic_auth';

export const authOptions = {
  providers: [
    CredentialsProvider({
      name: "Credentials",
      // `credentials` is used to generate a form on the sign in page.
      // You can specify which fields should be submitted, by adding keys to the `credentials` object.
      // e.g. domain, username, password, 2FA token, etc.
      // You can pass any HTML attribute to the <input> tag through the object.
      credentials: {
        username: {label: "Username", type: "text", placeholder: "username"},
        password: {label: "Password", type: "password"}
      },
      async authorize(credentials, req) {
        if (checkAuth(credentials.username, credentials.password)) {
          return {
            "name": "Admin",
            "username": "admin"
          }
        }

        return null;
      }
    })
  ],
  callbacks: {
    async jwt({token, account}) {
      // Persist the OAuth access_token to the token right after signin
      if (account) {
        token.accessToken = account.access_token
        // token.userRole = "user"
      }
      return token
    },
    async session({session, token, user}) {
      // Send properties to the client, like an access_token from a provider.
      session.accessToken = token.accessToken
      // session.userRole = "user"
      return session
    },
    async redirect({ url, baseUrl }) {
      return baseUrl
    }
  }
}

export default NextAuth(authOptions)
