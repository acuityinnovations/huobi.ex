defmodule ExHuobi.Rest.Account.GetTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExHuobi.Margin.Rest.Account, as: Rest

  setup_all do
    HTTPoison.start()
    :ok
  end

  setup do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes", "fixture/custom_cassettes")
    :ok
  end

  test "returns all account" do
    use_cassette "rest/accounts/get", custom: true do
      {:ok, accounts} = Rest.get()

      assert length(accounts) == 2
    end
  end
end
