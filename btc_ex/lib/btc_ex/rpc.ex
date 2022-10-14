defmodule BtcEx.RPC do
  @client Tesla.client([
            {Tesla.Middleware.BasicAuth, username: "asd", password: "asd"},
            {Tesla.Middleware.Headers, [{"content-type", "text/plain"}]}
          ])

  def get_mempool_info() do
    send_request("getmempoolinfo", [])
  end

  def get_raw_mempool(verbose) do
    send_request("getrawmempool", [verbose])
  end

  def list_unspent() do
    send_request("listunspent", [])
  end

  def load_wallet(filename) do
    send_request("loadwallet", filename)
  end

  def generate_raw_transaction(txid, vout, address, amount) do
    input = %{
      "txid" => txid,
      "vout" => vout
    }

    output = %{
      "#{address}" => amount
    }

    send_request("createrawtransaction", [[input], [output]])
  end

  def create_wallet(wallet_name) do
    send_request("createwallet", [wallet_name])
  end

  def sign_raw_transaction(message) do
    send_request("signmessage", ["bcrt1q5cc0xvj38546a2zeggph5d3ewnpqjpe9u7q3d8", message])
  end

  def get_tx_out(txid, vout) do
    send_request("gettxout", [txid, vout])
  end

  defp send_request(method, args) do
    payload = build_payload(method, args)

    {:ok, response} = Tesla.post(@client, "http://127.0.0.1:8332/", payload)
    response.body |> Jason.decode!()
  end

  defp build_payload(method, params) do
    %{
      jsonrpc: "1.0",
      id: Enum.random(1..9_999_999),
      method: method,
      params: params
    }
    |> Jason.encode!()
  end
end
