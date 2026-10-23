public interface TokenNames {
  public static final int EOF = 0;
  public static final int PLUS = 1;
  public static final int MINUS = 2;
  public static final int TIMES = 3;
  public static final int DIVIDE = 4;
  public static final int EQ = 5;
  public static final int LT = 6;
  public static final int GT = 7;
  public static final int AND = 8;
  public static final int OR = 9;
  public static final int LPAREN = 10;
  public static final int RPAREN = 11;
  public static final int LBRACK = 12;
  public static final int RBRACK = 13;
  public static final int LBRACE = 14;
  public static final int RBRACE = 15;
  public static final int COMMA = 16;
  public static final int DOT = 17;
  public static final int SEMICOLON = 18;
  public static final int ASSIGN = 19;
  public static final int ARRAY = 20;
  public static final int CLASS = 21;
  public static final int EXTENDS = 22;
  public static final int NEW = 23;
  public static final int NIL = 24;
  public static final int IF = 25;
  public static final int ELSE = 26;
  public static final int WHILE = 27;
  public static final int RETURN = 28;
  public static final int TYPE_INT = 29;
  public static final int TYPE_STRING = 30;
  public static final int TYPE_VOID = 31;
  public static final int ID = 32;
  public static final int INT = 33;
  public static final int STRING = 34;

  public static String nameOf(int token) {
    switch (token) {
      case EOF: return "EOF";
      case PLUS: return "PLUS";
      case MINUS: return "MINUS";
      case TIMES: return "TIMES";
      case DIVIDE: return "DIVIDE";
      case EQ: return "EQ";
      case LT: return "LT";
      case GT: return "GT";
      case AND: return "AND";
      case OR: return "OR";
      case LPAREN: return "LPAREN";
      case RPAREN: return "RPAREN";
      case LBRACK: return "LBRACK";
      case RBRACK: return "RBRACK";
      case LBRACE: return "LBRACE";
      case RBRACE: return "RBRACE";
      case COMMA: return "COMMA";
      case DOT: return "DOT";
      case SEMICOLON: return "SEMICOLON";
      case ASSIGN: return "ASSIGN";
      case ARRAY: return "ARRAY";
      case CLASS: return "CLASS";
      case EXTENDS: return "EXTENDS";
      case NEW: return "NEW";
      case NIL: return "NIL";
      case IF: return "IF";
      case ELSE: return "ELSE";
      case WHILE: return "WHILE";
      case RETURN: return "RETURN";
      case TYPE_INT: return "TYPE_INT";
      case TYPE_STRING: return "TYPE_STRING";
      case TYPE_VOID: return "TYPE_VOID";
      case ID: return "ID";
      case INT: return "INT";
      case STRING: return "STRING";
      default: return null;
    }
  }
}
