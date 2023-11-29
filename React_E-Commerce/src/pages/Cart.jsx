import React from "react";
import { Navbar } from "../components";
import { Link } from "react-router-dom";
import { useState } from "react";
import { useEffect } from "react";

const Cart = () => {
  const [orderInfo, setOrderInfo] = useState(undefined);
  const [refetch, setRefetch] = useState(true);

  useEffect(() => {
    if (refetch)
      fetch("http://localhost:3002/orders", {
        method: "GET",
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
          Authorization: `Bearer ${localStorage.getItem("token")}`,
        },
      })
        .then((response) => response.json())
        .then((data) => {
          if (data?.error) {
            alert(data?.error);
          } else {
            setOrderInfo(data);
          }
        })
        .catch((err) => console.log(err))
        .finally(() => setRefetch(false));
  }, [refetch]);

  const EmptyCart = () => {
    return (
      <div className="container">
        <div className="row">
          <div className="col-md-12 py-5 bg-light text-center">
            <h4 className="p-3 display-5">Your Cart is Empty</h4>
            <Link to="/" className="btn  btn-outline-dark mx-4">
              <i className="fa fa-arrow-left"></i> Continue Shopping
            </Link>
          </div>
        </div>
      </div>
    );
  };

  const updateItem = (productId, payload) => {
    fetch(`http://localhost:3002/order_item/${productId}`, {
      method: "PUT",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
        Authorization: `Bearer ${localStorage.getItem("token")}`,
      },
      body: JSON.stringify(payload),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data?.error) alert(data.error);
        else setRefetch(true);
      })
      .catch((err) => alert(err.error));
  };

  const addItem = (product) => {
    updateItem(product?.info?.id, {
      items: { quantity: product.quantity + 1 },
    });
  };

  const removeItem = (product) => {
    updateItem(product?.info?.id, {
      items: { quantity: product.quantity - 1 },
    });
  };

  const deleteItem = (productId) => {
    fetch(`http://localhost:3002/order_item/${productId}`, {
      method: "DELETE",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
        Authorization: `Bearer ${localStorage.getItem("token")}`,
      },
    })
      .then((response) => response?.status === 204 && setRefetch(true))
      .then((data) => {
        if (data?.error) alert(data?.error);
        else setRefetch(true);
      })
      .catch((err) => alert(err.error));
  };

  const ShowCart = () => {
    return (
      <>
        <section className="h-100 gradient-custom">
          <div className="container py-5">
            <div className="row d-flex justify-content-center my-4">
              <div className="col-md-8">
                <div className="card mb-4">
                  <div className="card-header py-3">
                    <h5 className="mb-0">Item List</h5>
                  </div>
                  <div className="card-body">
                    {orderInfo?.items.map((item) => {
                      return (
                        <div key={item.id}>
                          <div className="row d-flex align-items-center">
                            <div className="col-lg-3 col-md-12">
                              <div
                                className="bg-image rounded"
                                data-mdb-ripple-color="light"
                              >
                                <img
                                  src={item?.info?.image_urls?.[0]}
                                  alt={item.info.name}
                                  width={100}
                                  height={75}
                                />
                              </div>
                            </div>

                            <div className="col-lg-5 col-md-6">
                              <p>
                                <strong>{item.info.name}</strong>
                              </p>
                            </div>

                            <div className="col-lg-4 col-md-6">
                              <div
                                className="d-flex align-items-center mb-4"
                                style={{ maxWidth: "300px" }}
                              >
                                <button
                                  className="btn px-3"
                                  onClick={() => removeItem(item)}
                                >
                                  <i className="fas fa-minus"></i>
                                </button>

                                <i className="mx-5">{item.quantity}</i>

                                <button
                                  className="btn px-3"
                                  onClick={() => addItem(item)}
                                >
                                  <i className="fas fa-plus"></i>
                                </button>
                                <button
                                  className="btn px-3"
                                  onClick={() => deleteItem(item?.info?.id)}
                                >
                                  <i className="fas fa-trash"></i>
                                </button>
                              </div>

                              <p className="text-start text-md-center">
                                <strong>
                                  <span className="text-muted">
                                    {item.quantity}
                                  </span>{" "}
                                  x ${item.price}
                                </strong>
                              </p>
                            </div>
                          </div>

                          <hr className="my-4" />
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>
              <div className="col-md-4">
                <div className="card mb-4">
                  <div className="card-header py-3 bg-light">
                    <h5 className="mb-0">Order Summary</h5>
                  </div>
                  <div className="card-body">
                    <ul className="list-group list-group-flush">
                      <li className="list-group-item d-flex justify-content-between align-items-center border-0 px-0 pb-0">
                        Products ({orderInfo?.items.length})
                      </li>
                      <li className="list-group-item d-flex justify-content-between align-items-center border-0 px-0 mb-3">
                        <div>
                          <strong>Total amount</strong>
                        </div>
                        <span>
                          <strong>${Math.round(orderInfo.total_price)}</strong>
                        </span>
                      </li>
                    </ul>

                    <Link
                      to="/checkout"
                      className="btn btn-dark btn-lg btn-block disabled"
                    >
                      Go to checkout
                    </Link>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>
      </>
    );
  };

  return (
    <>
      <Navbar />
      <div className="container my-3 py-3">
        <h1 className="text-center">Cart</h1>
        <hr />
        {orderInfo?.items.length > 0 ? <ShowCart /> : <EmptyCart />}
      </div>
    </>
  );
};

export default Cart;
