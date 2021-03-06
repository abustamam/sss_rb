#
# parser.rex
#
#   Copyright (c) 2014 Glauco Vinicius <gl4uc0@gmail.com>
#
#   This program is free software.
#   You can distribute/modify this program under the terms of
#   the GNU Lesser General Public License version 2 or later.
#

module SSS
class Parser
macro
  BLANK                 \s+
  COMMENTS              \/\/.*
  DIGIT                 [0-9]
  NUMBER                {DIGIT}+(\.{DIGIT}+)? # matches: 10 and 3.14
  NAME                  [a-zA-Z][\w\-]* # matches: body, background-color and myClassName
  SELECTOR              (\.|\#|\:\:|\:){NAME} # matches: #id, .class, :hover and ::before
rule
  {COMMENTS}            # ignores comments

  {BLANK}               # ignores spaces, line breaks

  # Numbers
  {NUMBER}(px|em|\%)    { [:DIMENSION, text] } # 10px, 1em, 50%
  {NUMBER}              { [:NUMBER, text] } # 0
  \#[0-9A-Fa-f]{3,6}    { [:COLOR, text] } # #fff, #f0f0f0

  # Strings
  \"[^"]*\"             { [:STRING, text] }
  \'[^']*\'             { [:STRING, text] }

  # URI
  url\([^\)]+\)         { [:URI, text] }  # url(image.jpg)

  # imports
  \#import               { [:IMPORT, text] } # @#import 'file.sss'

  # Selectors
  {SELECTOR}            { [:SELECTOR, text] } # .class, #id
  {NAME}{SELECTOR}      { [:SELECTOR, text] } # div.class, body#id

  # Variables
  @{NAME}               { [:VARIABLE, text] } # @variable

  # Identifier
  {NAME}                { [:IDENTIFIER, text] } # body, font-size

  .                     { [text, text] } # {, }, +, :, ;
end
end
