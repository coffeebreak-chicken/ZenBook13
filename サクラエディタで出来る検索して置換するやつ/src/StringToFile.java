import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.IOException;


import java.nio.file.StandardCopyOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets ;

public class StringToFile {
	public static void main(String args[]){
		
		// 設計書ディレクトリの絶対パス
		String AbsolutePath = "C:/Users/Student/Documents/GitHub/ZenBook13/サクラエディタで出来る検索して置換するやつ/resource";
		
		// 置換する文字列などを記載するプロパティファイル
		String propertieFilePath = "C:/Users/Student/Documents/GitHub/ZenBook13/サクラエディタで出来る検索して置換するやつ/src/Property.prop";
		
		// 拡張子md
		String extentions = ".md";
		
		// ファイルのうち設計書ファイル(.md)だけを格納する
		List<File> mdFiles = new ArrayList<File>();
		
		// 置換した設計書ファイル数のカウント用
		int replaceCount = 0;
		
		try {
			// 設計書ディレクトリを扱う準備
			File dir = new File(AbsolutePath);
			
			// 設計書ディレクトリ内のファイル一覧で回す
			File[] files = dir.listFiles();
			for (int i = 0; i < files.length; i++) {
				
				// 拡張子を指定(.md)
				if (files[i].isFile() & files[i].getName().endsWith(extentions)) {
					// 設計書ファイル(.md)がある場合は、設計書用の作業リストに格納する
					mdFiles.add(files[i]);
				}
			}
			
			// 設計書ファイル(.md)が無い場合はメッセージ表示
			if (mdFiles == null | mdFiles.size() == 0) {
				System.out.println("*設計書ファイルが存在しません.*");
				System.out.println("ディレクトリ：" + AbsolutePath + "*");
			}
			
			// 設計書ファイル(.md)があるだけ置換処理を回す
			for (File mdFile : mdFiles) {
				
				// 設計書ファイルのパスを取得
				Path mdFilePath = mdFile.toPath();
				Path mdFilePathBackup = Paths.get(mdFilePath + "_backup");
				
				// ①設計書ファイルを読み込む
				String content = new String(Files.readAllBytes(mdFilePath), "UTF-8");
				
				// ②プロパティファイルから置換する文字列などを取得する
				Properties properties = new Properties();
				InputStreamReader reader = new InputStreamReader(new FileInputStream(propertieFilePath), StandardCharsets.UTF_8);
				properties.load(reader);
				String regex = properties.getProperty("regex"); //置換したい文字列（正規表現）
				String replacement = properties.getProperty("replacement"); //置換後の文字列
				// System.out.println("regex： " + regex);
				// System.out.println("replacement： " + replacement);
				
				// ③置換用の正規表現パターンをコンパイル
				Pattern regexPattern = Pattern.compile(regex);
				
				// 置換前表示＆置換対象があるかをファイル毎に判断
				boolean isMatch = beforeReplacement(content ,regexPattern);
				
				// 設計書ファイルに置換対象の文字列が存在する場合のみ置換処理実行
				if (isMatch) {
				
					// ④設計書ファイルを退避しておく(上書き許可）
					// Files.copy(mdFilePath, mdFilePathBackup", StandardCharsets.UTF_8);
					Files.copy(mdFilePath, mdFilePathBackup, StandardCopyOption.REPLACE_EXISTING);
				
					// ⑤正規表現で設計書ファイル（置換前）を検索する
					Matcher matcher = regexPattern.matcher(content);
				
					// ⑥置換を実行
					String updatedContent = matcher.replaceAll(replacement);
					
					// ⑦ファイルに巻き戻す
					Files.write(mdFilePath, updatedContent.getBytes("UTF-8"));
						
					// 置換した設計書ファイル数カウントアップ
					replaceCount = replaceCount +1;
						
					// TODO ちゃんと判断してメッセージ出したい
					System.out.println("置換が完了しました！\n");
						
					// 置換後表示
					afterReplacement(updatedContent ,replacement);
				}
					
				if (!isMatch) {
				// 設計書ファイルに置換対象の文字列が存在しなければ、その旨メッセージを出して終了
					System.out.println("*設計書ファイル：" + mdFile.getName() + "には置換対象文字列が存在しません.*");
					
				}
			}
			if (replaceCount==0) {
				System.out.println("置換した設計書ファイルはありませんでした.\n");
			}
			
			System.out.println("置換した設計書ファイル数：" + replaceCount + "件です.\n");
			
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// 何もしない
		}
	}
	
	
	/*
	* 置換前を表示します.
	* 置換対象化のフラグ(ture/falsew)を返します.
	*/
	public static boolean beforeReplacement(String content, Pattern regexPattern) {
		// 置換対象フラグ
		boolean isMatch = false;
		
		// A-1.設計書ファイル（置換前）の内容を行ごとに分割
		String[] linesBefore = content.split("\r?\n");
		
		// A-2.各行に対して正規表現で検索を行う
		for (String line : linesBefore) {
			Matcher matcher = regexPattern.matcher(line);
			if (matcher.find()) {
				// 検索に引っかかった場合メッセージ
				System.out.println("該当行（置換前）： " + line);
				// 検索に引っかかった場合、置換対象ありフラグをオン
				isMatch = true;
			}
		}
		return isMatch;
	}
	
	public static void afterReplacement(String updatedContent, String replacement){
		// B-1.置換後のファイルの内容を行ごとに分割
		String[] linesAfter = updatedContent.split("\r?\n");
					
		// 置換後のあるべき姿をコンパイル
		Pattern patternAfter = Pattern.compile(replacement);
					
		// B-2.各行に対して正規表現で検索を行う
		for (String line : linesAfter) {
			Matcher matcherAfter = patternAfter.matcher(line);
			if (matcherAfter.find()) {
				System.out.println("該当行（置換後）： " + line);
			}
		}
	
	}
}