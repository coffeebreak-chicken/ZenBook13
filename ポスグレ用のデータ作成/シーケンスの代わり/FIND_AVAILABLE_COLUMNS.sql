-- 10000～11000の範囲内で未使用のIDを検索する（範囲は任意）
-- GENERATE_SERIESで仮想の10000～11000の数値をもつテーブルを生成
-- 検索したいテーブルとJOINし、存在しない（=使用可能）カラムを表示する
SELECT column
FROM GENERATE_SERIES(10000, 11000) AS vtbl(column) -- 生成される数値に「column」という列名を付与し、「SELECT column」を可能にする
WHERE NOT EXISTS (
    SELECT 1
    FROM TableName tbl
    WHERE tbl.column = vtbl.column
);
