all: classfiles expr.jar doc/user-doc.html jdoc example/GraphApplet.class example/expr.jar

classfiles:
	~/bin/javac -O expr/*.java

classfiles = $(shell echo expr/{BinaryExpr,Parser,Token,ConditionalExpr,Scanner,UnaryExpr,Expr,SyntaxException,Variable,LiteralExpr}.class)

expr.jar:
	jar cf expr.jar $(classfiles)

doc/user-doc.html: doc/table.awk doc/table.text doc/user-doc.latte doc/style.latte
	nawk -f doc/table.awk doc/table.text | cat doc/style.latte - | latte-html >doc/user-doc.html

jdoc:
	cd javadoc; javadoc -classpath .. ../expr/*.java

example/BasicGraphApplet.class: example/BasicGraphApplet.java example/expr.jar
	#javac -classpath example/expr.jar:example example/BasicGraphApplet.java
	/home/me/bin/javac -sourcepath example/expr.jar:example example/BasicGraphApplet.java

# We need a copy of expr.jar in the example directory because of 
# appletviewer's lame security rules.
example/expr.jar: expr.jar
	cp expr.jar example/expr.jar
