SELECT
  Algorithm,
  SUM(TradeProfitLoss) as TotalProfitLoss,
  AVG(TradeProfitLoss) as AverageProfitLoss,
  COUNT(*) as NumberOfTrades
FROM (
  SELECT
    CASE SUBSTR(TargetCompID, 0, 4)
      WHEN 'MOMO' THEN 'Momentum'
      WHEN 'LUCK' THEN 'Feeling Lucky'
      WHEN 'PRED' THEN 'Prediction'
      ELSE 'Other'
    END AS Algorithm,
    CASE (Sides[OFFSET(0)]).Side
      WHEN 'LONG' THEN (StrikePrice - LastPx)
      WHEN 'SHORT' THEN (LastPx - StrikePrice)
    END AS TradeProfitLoss
  FROM
    `bigquery-public-data.cymbal_investments.trade_capture_report`
)
GROUP BY Algorithm
ORDER BY TotalProfitLoss DESC;
