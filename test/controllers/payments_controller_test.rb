require 'test_helper'

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment = payments(:one)
  end

  test "should get index" do
    get payments_url
    assert_response :success
  end

  test "should get new" do
    get new_payment_url
    assert_response :success
  end

  test "should create payment" do
    assert_difference('Payment.count') do
      post payments_url, params: { payment: { change: @payment.change, departure_date: @payment.departure_date, discount: @payment.discount, generic_price_id: @payment.generic_price_id, paid_with: @payment.paid_with, payment_type_id: @payment.payment_type_id, service_id: @payment.service_id, ticket: @payment.ticket, user_id: @payment.user_id, worforce: @payment.worforce } }
    end

    assert_redirected_to payment_url(Payment.last)
  end

  test "should show payment" do
    get payment_url(@payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_url(@payment)
    assert_response :success
  end

  test "should update payment" do
    patch payment_url(@payment), params: { payment: { change: @payment.change, departure_date: @payment.departure_date, discount: @payment.discount, generic_price_id: @payment.generic_price_id, paid_with: @payment.paid_with, payment_type_id: @payment.payment_type_id, service_id: @payment.service_id, ticket: @payment.ticket, user_id: @payment.user_id, worforce: @payment.worforce } }
    assert_redirected_to payment_url(@payment)
  end

  test "should destroy payment" do
    assert_difference('Payment.count', -1) do
      delete payment_url(@payment)
    end

    assert_redirected_to payments_url
  end
end
