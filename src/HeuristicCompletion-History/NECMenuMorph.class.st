"
I show the possible completions in a menu like appearance. The user may choose an entry from my list and complete the word he was typing in the editor. I'm showed with the Tab key and will be deleted when with ESC key or when a successful completion occurs. The following keystrokes are supported:

Ctrl-Space or Tab: Open a new morph. Tab requires at least one character in front of the cursor. When already open complete the selected entry. 
Esc: Close me
Ctrl+u: Change to untyped mode, so I show all selectors of all classes in the system and the variables that are accessible to the current context.
Arrow Up: Move one entry up.
Arrow Down: Move one entry down
Enter: (like Ctrl-Space and Tab): Complete with the selected item and close the morph
any letter or digit: Narrow the completion further
Ctrl+t: Toggle the expand flag. When expand is disabled, you don't see selectors belonging to Object and ProtoObject. 


"
Class {
	#name : 'NECMenuMorph',
	#superclass : 'Morph',
	#instVars : [
		'selected',
		'firstVisible',
		'titleStringMorph',
		'context',
		'pageHeight',
		'detailMorph',
		'detailPosition',
		'engine',
		'isDetailMorphVisible'
	],
	#category : 'HeuristicCompletion-History',
	#package : 'HeuristicCompletion-History'
}

{ #category : 'preferences-colors' }
NECMenuMorph class >> backgroundColor [
	^NECPreferences backgroundColor
]

{ #category : 'preferences' }
NECMenuMorph class >> convertToSHSymbol: aSymbol [
	^ (SHRBTextStyler new attributesFor: aSymbol) isNotEmpty
		ifTrue: [ aSymbol ]
		ifFalse: [ #default ]
]

{ #category : 'instance creation' }
NECMenuMorph class >> engine: aCompletionEngine position: aPoint [
	^ self new engine: aCompletionEngine position: aPoint
]

{ #category : 'help text' }
NECMenuMorph class >> explanationAttributes [
	^{TextIndent tabs: 2}
]

{ #category : 'help text' }
NECMenuMorph class >> helpText [
	| stream |
	stream := TextStream on: Text new.
	self
		section: 'character completion'
		on: stream.
	self
		shortcut: 'works on'
		text: ' [] {} () <> '''' ""'
		on: stream.
	self
		shortcut: 'usage 1'
		text: 'enter open character - closing character is entered as well'
		on: stream.
	self
		shortcut: 'usage 2'
		text: 'select some text, enter a smart character and the selected text get surrounded by the opening and closing character.'
		on: stream.
	self
		section: 'open/close menu'
		on: stream.
	self
		shortcut: 'ctrl-space or tab'
		text: 'open the completion menu'
		on: stream.
	self
		shortcut: 'ESC'
		text: 'close menu'
		on: stream.
	self
		shortcut: 'ctrl-h'
		text: 'open this help'
		on: stream.
	self
		section: 'menu navigation'
		on: stream.
	self
		shortcut: 'Arrows up/down'
		text: 'move the selection up and down'
		on: stream.
	self
		shortcut: 'Page up/down'
		text: 'page up and down'
		on: stream.
	self
		shortcut: 'Home/End'
		text: 'move to first or last page of the menu'
		on: stream.
	self
		section: 'show details and browse'
		on: stream.
	self
		shortcut: 'right arrow (detail closed)'
		text: 'show details about the selected item. This may be the type of the variable, the source of a method or the implementors of the selector.'
		on: stream.
	self
		shortcut: 'right arrow (detail open)'
		text: 'open a new browser for the selected item.'
		on: stream.
	self
		shortcut: 'left arrow'
		text: 'close the details'
		on: stream.
	self
		section: 'changing menu contents'
		on: stream.
	self
		shortcut: 'ctrl-u'
		text: 'switch to untyped mode in a typed menu'
		on: stream.
	self
		shortcut: 'ctrl-t'
		text: 'filter out methods of class Object in a typed menu. press again to make the reappear.'
		on: stream.
	self
		shortcut: 'alphanumeric character'
		text: 'filter the menu to the given input'
		on: stream.
	self
		shortcut: 'backspace'
		text: 'delete an input character, adjust menu to the new input.'
		on: stream.
	self
		section: 'inserting completion'
		on: stream.
	self
		shortcut: 'ctrl-space or tab'
		text: 'close the menu and insert selected completion. if there only one item left in the menu this done automaticly.'
		on: stream.
	^ stream contents
]

{ #category : 'help text' }
NECMenuMorph class >> helpTitle [

	^ 'Completion Keyboard Help'
]

{ #category : 'preferences' }
NECMenuMorph class >> itemHeight [
	^ (self selectFontFor: #default) height + 2
]

{ #category : 'preferences' }
NECMenuMorph class >> itemWidth [
	^ 250
]

{ #category : 'preferences' }
NECMenuMorph class >> maxLength [
	^ 20
]

{ #category : 'preferences-fonts' }
NECMenuMorph class >> messageFont [
	^ StandardFonts menuFont
]

{ #category : 'preferences' }
NECMenuMorph class >> scrollArrowSize [
	^ 8
]

{ #category : 'preferences-colors' }
NECMenuMorph class >> scrollColor [
	^ self theme selectionColor
]

{ #category : 'help text' }
NECMenuMorph class >> section: aString on: aTextStream [
	aTextStream
		withAttributes: self sectionAttributes
		do: [aTextStream nextPutAll: aString].
	aTextStream cr
]

{ #category : 'help text' }
NECMenuMorph class >> sectionAttributes [
	^ {TextEmphasis bold}
]

{ #category : 'preferences' }
NECMenuMorph class >> selectColorFor: aSymbol [
	| attribute |
	attribute := self convertToSHSymbol: aSymbol.
	^ (SHRBTextStyler new attributesFor: attribute) first color
]

{ #category : 'preferences-fonts' }
NECMenuMorph class >> selectFontFor: aSymbol [
	| emphasized attributes |
	attributes := SHRBTextStyler new
		attributesFor: (self convertToSHSymbol: aSymbol).
	emphasized := attributes size > 1
		ifTrue: [ attributes second emphasisCode ]
		ifFalse: [ 0 ].
	^ StandardFonts codeFont
		emphasized: emphasized
]

{ #category : 'help text' }
NECMenuMorph class >> shortcut: aString text: secondString on: aTextStream [
	aTextStream
		withAttributes: self shortcutAttributes
		do: [aTextStream nextPutAll: aString;
				 cr].
	aTextStream
		withAttributes: self explanationAttributes
		do: [aTextStream nextPutAll: secondString;
				 cr]
]

{ #category : 'help text' }
NECMenuMorph class >> shortcutAttributes [
	^ {TextIndent  tabs: 1. TextEmphasis italic }
]

{ #category : 'preferences-fonts' }
NECMenuMorph class >> titleFont [
	^ StandardFonts windowTitleFont
]

{ #category : 'actions' }
NECMenuMorph >> browse [
	(self selectedEntry browse)
		ifTrue: [ engine closeMenu ]
]

{ #category : 'actions' }
NECMenuMorph >> close [
	self delete
]

{ #category : 'initialization' }
NECMenuMorph >> createTitle [
	| titleString transformationMorph |
	titleString := context title ifNil: [ ^ self ].

	titleStringMorph := StringMorph new.
	titleStringMorph
		contents: titleString;
		font: self class messageFont.

	transformationMorph := TransformationMorph new.
	transformationMorph rotationDegrees: -90.0;
		offset: self position negated - (0 @ (titleStringMorph width + 12));
		addMorph: titleStringMorph.

	self addMorph: transformationMorph.
	self resize
]

{ #category : 'paging' }
NECMenuMorph >> currentPage [
	^(self selected - 1 // self pageHeight ) + 1
]

{ #category : 'private' }
NECMenuMorph >> delete [
	super delete.
	engine menuClosed
]

{ #category : 'drawing' }
NECMenuMorph >> detailMessage [

	^ self itemsCount isZero
		  ifTrue: [ 'no entries' ]
		  ifFalse: [ 'cmd+B browse entry' ]
]

{ #category : 'accessing' }
NECMenuMorph >> detailPosition: aPoint [
	detailPosition := aPoint.

	self updateDetail
]

{ #category : 'drawing' }
NECMenuMorph >> drawBottomScrollArrowOn: aCanvas [
	| aPoligon point arrowHeight |
	point := self bounds bottomLeft translateBy: 6 @ -12.
	arrowHeight := self class scrollArrowSize.
	aPoligon := Array
		with: point
		with: (point translateBy: arrowHeight @ 0)
		with: (point translateBy: (arrowHeight / 2) @ arrowHeight).
	aCanvas
		drawPolygon: aPoligon
		fillStyle: Color black
]

{ #category : 'drawing' }
NECMenuMorph >> drawLine: index on: aCanvas rectangle: rectangle [
	| necEntry font type string preString highlightRectangle |

	necEntry := context entries at: index.
	string := necEntry contents.
	preString := string asLowercase findString: context completionToken asLowercase.
	preString := preString <= 0
		ifFalse: [ string first: preString - 1 ]
		ifTrue: [ String empty ].
	type := necEntry hightlightSymbol.
	font := self selectFont: type.
	index = self selected
		ifTrue: [
			| rect |
			rect := rectangle withBottom: rectangle top + self class itemHeight.
			aCanvas fillRectangle: rect color: self class scrollColor.
			self detailPosition: rect topRight ].
	highlightRectangle := rectangle translateBy: (font widthOfString: preString) @ 0.
	highlightRectangle := highlightRectangle withWidth: (font widthOfString: context completionToken).
	aCanvas
		clipBy: rectangle
		during: [ :c | c fillRectangle: highlightRectangle color: (Color gray alpha: 0.3) ].
	aCanvas
		drawString: string
		in: (rectangle insetBy: 1)
		font: font
		color: (self selectColor: type)
]

{ #category : 'drawing' }
NECMenuMorph >> drawMessageOn: aCanvas in: rectangle [
	self hasMessage ifFalse: [ ^ self ].
	context hasEntries ifTrue: [
		aCanvas
			line: rectangle topLeft
			to: rectangle topRight
			color: Color gray ].
	self
		drawModelMessageOn: aCanvas
		in: rectangle
]

{ #category : 'drawing' }
NECMenuMorph >> drawModelMessageOn: aCanvas in: rectangle [
	| message |
	message := context hasMessage
		ifTrue: [ context message ]
		ifFalse: [ self detailMessage ].
	aCanvas
		drawString: message
		in: rectangle
		font: self class messageFont
		color: Color gray
]

{ #category : 'drawing' }
NECMenuMorph >> drawOn: aCanvas [
	| rectangle |
	"draw background"
	super drawOn: aCanvas.

	rectangle := self bounds insetBy: 1.
	rectangle := rectangle bottom: rectangle top + self class itemHeight.
	rectangle := rectangle left: rectangle left + 20.

	self extent: self extent.
	self firstVisible > 1
		ifTrue: [ self drawTopScrollArrowOn: aCanvas ].
	self lastVisible ~= self itemsCount
		ifTrue: [ self drawBottomScrollArrowOn: aCanvas ].

	context hasEntries ifTrue: [
		self firstVisible to: self lastVisible do: [ :index |
			self drawLine: index on: aCanvas rectangle: rectangle.
			rectangle := self prepareRectForNextRow: rectangle ]].

	self
		drawMessageOn: aCanvas
		in: rectangle
]

{ #category : 'drawing' }
NECMenuMorph >> drawTopScrollArrowOn: aCanvas [
	| aPolygon point arrowHeight |
	arrowHeight := self class scrollArrowSize.
	point := self bounds topLeft translateBy: 6 @ 11.
	aPolygon := Array
				with: point
				with: (point translateBy: arrowHeight @ 0)
				with: (point translateBy: arrowHeight / 2 @ arrowHeight negated).
	aCanvas
		drawPolygon: aPolygon
		fillStyle: Color black
]

{ #category : 'actions' }
NECMenuMorph >> end [
	self gotoPage: self pageCount.
	self changed
]

{ #category : 'initialization' }
NECMenuMorph >> engine: aCompletionEngine position: aPoint [
	engine := aCompletionEngine.
	context := engine context.
	self position: aPoint - (20 @ 0).
	self refreshSelection.
	self createTitle.
	self openInWorld
]

{ #category : 'private' }
NECMenuMorph >> firstVisible [
	^firstVisible min: context entryCount
]

{ #category : 'paging' }
NECMenuMorph >> gotoPage: anInteger [
	| item |
	item := (anInteger - 1) * self pageHeight + 1.
	item >= self itemsCount
		ifTrue: [ ^ self ].
	item := item max: 1.
	firstVisible := item.
	self selected: firstVisible
]

{ #category : 'event handling' }
NECMenuMorph >> handlesMouseDown: anEvent [
	^ true
]

{ #category : 'actions' }
NECMenuMorph >> hasDetail [

	^ detailMorph isNotNil
]

{ #category : 'drawing' }
NECMenuMorph >> hasMessage [
	^ true
]

{ #category : 'accessing' }
NECMenuMorph >> height [
	^ 10
]

{ #category : 'actions' }
NECMenuMorph >> help [
	self class helpText asMorph openInWindowLabeled: self class helpTitle
]

{ #category : 'actions' }
NECMenuMorph >> hideDetail [
	detailMorph ifNil: [ ^ false ].
	self removeMorph: detailMorph.
	detailMorph delete.
	detailMorph := nil.
	self changed.
	^ true
]

{ #category : 'actions' }
NECMenuMorph >> home [
	self gotoPage: 1.
	self changed
]

{ #category : 'initialization' }
NECMenuMorph >> initialize [
	super initialize.
	self color: self class backgroundColor.
	self borderStyle: (BorderStyle color: Color gray width: 1).
	isDetailMorphVisible := false
]

{ #category : 'private' }
NECMenuMorph >> insertSelected [
	
	| item |
	self delete.
	context hasEntries ifFalse: [^ false].
	context activateEntryAt: self selected.
	item := context activateEntryAt: self selected.
	self class environment codeChangeAnnouncer announce: (CompletionItemSelected new selectedItem: item).
	^ true
]

{ #category : 'private' }
NECMenuMorph >> isClosed [
	^ owner isNil
]

{ #category : 'private' }
NECMenuMorph >> itemsCount [
	^context entryCount
]

{ #category : 'private' }
NECMenuMorph >> lastVisible [

	^ (self firstVisible + self height-1)  min: (self itemsCount)
]

{ #category : 'event handling' }
NECMenuMorph >> mouseDown: evt [
	(self bounds containsPoint: evt cursorPoint)
		ifTrue: [
			evt wasHandled: true.
			^ self
				selectIndexAtPoint: evt cursorPoint;
				insertSelected ].

	super mouseDown: evt.
	evt wasHandled: false.
	self flag: #pharoFixMe "ugly hack".
	
	engine editor morph ifNotNil: [ :aMorph | 
		aMorph owner ifNotNil: [ :anOwner | 
			anOwner owner ifNotNil: [ :ownersOwner |
				ownersOwner
					takeKeyboardFocus;
					handleMouseDown: evt.
		 ] ] ].

	self close
]

{ #category : 'actions' }
NECMenuMorph >> moveDown [
	self selected: self selected + 1.
	(self selected > self lastVisible
			and: [self selected <= self itemsCount])
		ifTrue: [firstVisible := firstVisible + 1].
	self changed
]

{ #category : 'actions' }
NECMenuMorph >> moveUp [
	(self selected = 0
			and: [self firstVisible = 1])
		ifTrue: [^ self].
	self selected: self selected - 1.
	self selected < self firstVisible
		ifTrue: [firstVisible := firstVisible - 1].
	self changed
]

{ #category : 'paging' }
NECMenuMorph >> pageCount [
	| count |
	self itemsCount == self pageHeight
		ifTrue: [^ 1].
	count := self itemsCount // self pageHeight.
	(self itemsCount \\ self pageHeight) > 0
		ifTrue:[count := count + 1].
	^count
]

{ #category : 'actions' }
NECMenuMorph >> pageDown [
	self gotoPage: self currentPage + 1.
	self changed
]

{ #category : 'paging' }
NECMenuMorph >> pageHeight [
	^pageHeight
]

{ #category : 'actions' }
NECMenuMorph >> pageUp [
	self gotoPage: self currentPage - 1.
	self changed
]

{ #category : 'drawing' }
NECMenuMorph >> prepareRectForNextRow: aRectangle [
	^aRectangle translateBy: 0 @ self class itemHeight
]

{ #category : 'actions' }
NECMenuMorph >> refreshSelection [

	self selected: 0.
	firstVisible := 1.
	context hasEntries ifTrue: [ self selected: 1 ].
	self show.
	^ true
]

{ #category : 'drawing' }
NECMenuMorph >> resize [
	| extent height |
	firstVisible := 1.
	height := self visibleItemsCount * self class itemHeight.
	pageHeight := self height asInteger.
	self hasMessage ifTrue: [ height := height + self class itemHeight ].
	titleStringMorph ifNotNil: [
		"titleStringMorph width: (titleStringMorph width min: 100)."
		height := height max: titleStringMorph width + 30 ].
	extent := self class itemWidth @ height.
	self extent: extent
]

{ #category : 'drawing' }
NECMenuMorph >> selectColor: type [
	^ self class selectColorFor: type
]

{ #category : 'drawing' }
NECMenuMorph >> selectFont: aSymbol [
	^ self class selectFontFor: aSymbol
]

{ #category : 'event handling' }
NECMenuMorph >> selectIndexAtPoint: aPoint [
	| yPos  |
	yPos := aPoint y - self bounds top.
	selected := firstVisible + (yPos / self class itemHeight) floor.
	selected := selected min: context entries size max: 1
]

{ #category : 'accessing' }
NECMenuMorph >> selected [
	"Answer the value of selected"
	selected ifNil: [ selected := self firstVisible ].
	^ selected
]

{ #category : 'accessing' }
NECMenuMorph >> selected: aNumber [
	"Set the value of selected"
	context hasEntries ifTrue:
		[ ((1 to: self itemsCount) includes: aNumber) ifTrue: [ aNumber ~= selected ifTrue: [ selected := aNumber ] ] ]
]

{ #category : 'accessing' }
NECMenuMorph >> selectedEntry [
	^ context entries at: self selected
]

{ #category : 'actions' }
NECMenuMorph >> show [
	self resize.
	self activeHand ifNotNil: [ :hand | hand newMouseFocus: self ].
	self changed
]

{ #category : 'actions' }
NECMenuMorph >> showDetail [
	detailMorph ifNotNil: [ ^ self browse ].
	self itemsCount isZero ifTrue: [ ^ self ].
	detailMorph := NECDetailMorph new.
	self updateDetail.

]

{ #category : 'testing' }
NECMenuMorph >> takesKeyboardFocus [
	^ true
]

{ #category : 'private' }
NECMenuMorph >> updateDetail [

	detailMorph ifNil: [ ^ self ].
	detailPosition ifNil: [ ^ self ].	
		
	detailMorph
		entryDescription: self selectedEntry description;
		position: detailPosition menuWidth: self width.

	isDetailMorphVisible ifTrue: [ ^ self ].
	self addMorph: detailMorph.
	isDetailMorphVisible := true
]

{ #category : 'private' }
NECMenuMorph >> visibleItemsCount [

	^ self lastVisible - self firstVisible + 1
]
