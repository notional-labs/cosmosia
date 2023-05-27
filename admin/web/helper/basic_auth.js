
export const isEmpty = (value) => {
  return (value == null || value.length === 0);
}

export const checkAuth = (username, password) => {
  if (username === "admin" && password === process.env.ADMIN_PASSWORD) {
    return true;
  }
  return false;
}

export const checkBasicAuth = ({req, res}) => {
  try {
    const {authorization} = req.headers;
    if (isEmpty(authorization)) return false;

    const authValue = authorization.split(' ')[1]
    const [user, pwd] = atob(authValue).split(':')

    if (checkAuth(user, pwd) !== true) return false;
  } catch (e) {
    console.log(e.message);
    return false;
  }

  return true
}
