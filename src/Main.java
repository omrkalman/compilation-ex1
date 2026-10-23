import java.io.*;

import java_cup.runtime.Symbol;
   
public class Main
{
	static public void main(String argv[])
	{
		Lexer l;
		Symbol s;
		FileReader fileReader;
		PrintWriter fileWriter;
		String inputFileName = argv[0];
		String outputFileName = argv[1];
		StringBuilder out = new StringBuilder();
		boolean error = false;
		boolean isFirst = true;
		
		try
		{
			/********************************/
			/* [1] Initialize a file reader */
			/********************************/
			fileReader = new FileReader(inputFileName);

			/********************************/
			/* [2] Initialize a file writer */
			/********************************/
			fileWriter = new PrintWriter(outputFileName);
			
			/******************************/
			/* [3] Initialize a new lexer */
			/******************************/
			l = new Lexer(fileReader);

			/***********************/
			/* [4] Read next token */
			/***********************/
			s = l.next_token();


			/********************************/
			/* [5] Main reading tokens loop */
			/********************************/
			while (s.sym != TokenNames.EOF)
			{
				if (!isFirst)
				{
					out.append("\n");
				}
				if (s.sym==TokenNames.ERROR){
					error=true;
					break;
				}
				isFirst=false;
				
				/*********************/
				/* Build the string */
				/*********************/
				
				out.append(TokenNames.nameOf(s.sym));
				if (s.value!=null){
					out.append("(");
					out.append(s.value);
					out.append(")");
				}
				out.append("[");
				out.append(l.getLine());
				out.append(",");
				out.append(l.getTokenStartPosition());
				out.append("]");
	
				
				/***********************/
				/* [8] Read next token */
				/***********************/
				s = l.next_token();
			}
			
			/******************************/
			/* [9] Close lexer input file */
			/******************************/
			l.yyclose();

			/**************************/
			/* [10] Close output file */
			/**************************/
			System.out.print(error ? "ERROR" : out.toString());
			fileWriter.print(error ? "ERROR" : out.toString());
			fileWriter.close();
    	}
			     
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
}


