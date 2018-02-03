class Adapter {
  static findUser(username) {
    return fetch("http://localhost:3000/api/v1/profile", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ username }),
    }).then(res => res.json());
  }
}

export default Adapter;
