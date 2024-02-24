class Rack::Attack
  # 1分間に10リクエストを超えるリクエストをブロック
  throttle('req/ip', limit: 10, period: 1.minute) do |req|
    req.ip
  end

  # ブロックされたリクエストに対するレスポンスのカスタマイズ
  self.throttled_responder = lambda do |env|
    [
      429, # ステータスコード
      {'Content-Type' => 'application/json'},
      [{error: "Rate limit exceeded. Try again in 60 seconds."}.to_json]
    ]
  end
end