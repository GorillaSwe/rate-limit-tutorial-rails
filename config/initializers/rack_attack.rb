class Rack::Attack
  # 1分間に10リクエストを超えるリクエストをブロック
  throttle('req/ip', limit: 1, period: 1.minute) do |req|
    req.ip
  end

  # ブロックされたリクエストに対するレスポンスのカスタマイズ
  self.throttled_responder = lambda do |env|
    retry_after = (env['rack.attack.match_data'] || {})[:period]
    Rails.logger.warn "[Rack::Attack] Throttled: #{env['rack.attack.match_type']}"
    [
      429, # ステータスコード
      {'Content-Type' => 'application/json', 'Retry-After' => retry_after.to_s},
      [{error: "Rate limit exceeded. Try again in #{retry_after} seconds."}.to_json]
    ]
  end
end