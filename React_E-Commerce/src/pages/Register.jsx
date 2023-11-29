import React from "react";
import { Navbar } from "../components";
import { Link, useNavigate } from "react-router-dom";
import { useState } from "react";

const Register = () => {
  const navigate = useNavigate();
  const [values, setValues] = useState({
    email: "",
    password: "",
    passwordConfirmation: "",
  });
  const handleSubmit = (e) => {
    e.preventDefault();
    fetch("http://localhost:3000/register", {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        email: values.email,
        password: values.password,
        password_confirmation: values.passwordConfirmation,
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data?.error) {
          alert(data?.error);
        } else {
          localStorage.setItem("token", data.token);
          navigate("/");
        }
      })
      .catch((err) => alert(err.error));
  };

  return (
    <>
      <Navbar />
      <div className="container my-3 py-3">
        <h1 className="text-center">Register</h1>
        <hr />
        <div className="row my-4 h-100">
          <div className="col-md-4 col-lg-4 col-sm-8 mx-auto">
            <form onSubmit={handleSubmit}>
              <div className="form my-3">
                <label htmlFor="Email">Email address</label>
                <input
                  type="email"
                  className="form-control"
                  id="Email"
                  placeholder="name@example.com"
                  value={values.email}
                  onChange={(e) =>
                    setValues((prev) => ({ ...prev, email: e.target.value }))
                  }
                />
              </div>
              <div className="form my-3">
                <label htmlFor="Password">Password</label>
                <input
                  type="password"
                  className="form-control"
                  id="Password"
                  placeholder="Password"
                  value={values.password}
                  onChange={(e) =>
                    setValues((prev) => ({ ...prev, password: e.target.value }))
                  }
                />
              </div>
              <div className="form  my-3">
                <label htmlFor="Password Confirmation">
                  Password Confirmation
                </label>
                <input
                  type="password"
                  className="form-control"
                  id="Password Confirmation"
                  placeholder="Password"
                  value={values.passwordConfirmation}
                  onChange={(e) =>
                    setValues((prev) => ({
                      ...prev,
                      passwordConfirmation: e.target.value,
                    }))
                  }
                />
              </div>
              <div className="my-3">
                <p>
                  Already has an account?{" "}
                  <Link
                    to="/login"
                    className="text-decoration-underline text-info"
                  >
                    Login
                  </Link>{" "}
                </p>
              </div>
              <div className="text-center">
                <button className="my-2 mx-auto btn btn-dark" type="submit">
                  Register
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </>
  );
};

export default Register;
