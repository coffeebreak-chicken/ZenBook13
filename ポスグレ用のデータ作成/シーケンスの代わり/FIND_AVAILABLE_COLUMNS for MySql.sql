-- 10000～11000の範囲内で未使用のIDを検索する（範囲は任意）
-- WITH RECURSIVEで仮想の10000～11000の数値をもつテーブルを生成
-- 検索したいテーブルとJOINし、存在しない（=使用可能）カラムを表示する
WITH RECURSIVE vtbl AS (
    SELECT 10000 AS column
    UNION ALL
    SELECT column + 1 FROM vtbl WHERE column < 11000
)
SELECT vtbl.column
FROM vtbl
LEFT JOIN TableName tbl ON vtbl.column = tbl.column
WHERE tbl.column IS NULL;
