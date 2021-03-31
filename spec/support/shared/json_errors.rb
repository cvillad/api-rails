require 'rails_helper'

shared_examples_for "unauthorized_requests" do 
  let(:authentication_error) do 
    {
      "status": 401,
      "source": { "pointer": "/request/headers/authorization" },
      "title": "Unauthorized",
      "detail": "You need to login to authorize this request.",
    }
  end

  it "should return 401 status code" do 
    subject
    expect(response).to have_http_status(401)
  end

  it "should return a proper error body" do 
    subject
    expect(json[:errors]).to include(authentication_error)
  end
end

shared_examples_for "forbidden_requests" do
  let(:forbidden_error) do 
    {
      "status": 403,
      "source": { "pointer": "/request/headers/authorization" },
      "title": "Forbidden request",
      "detail": "You have no rights to access this resource",
    }
  end
  it "should return 403 status code" do 
    subject 
    expect(response).to have_http_status(:forbidden)
  end

  it "should return proper error json" do 
    subject 
    expect(json[:errors]).to include(forbidden_error)
  end
end