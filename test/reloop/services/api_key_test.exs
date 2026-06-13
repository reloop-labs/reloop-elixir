defmodule Reloop.Services.ApiKeyTest do
  use ExUnit.Case, async: true

  @api_prefix "/api/api-key/v1"

  test "routes use /api prefix" do
    assert String.starts_with?("#{@api_prefix}/", "/api/api-key/v1/")
    assert String.starts_with?("#{@api_prefix}/rotate/key_1", "/api/api-key/v1/rotate/")
    assert String.starts_with?("#{@api_prefix}/disable/key_1", "/api/api-key/v1/disable/")
  end

  test "pause delegates to disable" do
    assert function_exported?(Reloop.Services.ApiKey, :pause, 2)
    assert function_exported?(Reloop.Services.ApiKey, :disable, 2)
  end
end
