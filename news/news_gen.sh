#!/bin/sh

PANEL_STATE=" in"

while [ -n "$1" ];
do
FILE=$1
WEEK_JA=("日" "月" "火" "水" "木" "金" "土")

DATE="`grep '^#date:' "$FILE" | tail -1 | sed -e 's/^#date://g' | tr -d ' '`"
DATE_JA=`date '+%F' --date="$DATE"` || exit 1
DATE_EN=`date '+%d-%b-%Y' --date="$DATE"` || exit 1
DATE_JA2=`date "+%Y年%m月%d日(${WEEK_JA[\`date +%w --date="$DATE"\`]})" --date="$DATE"`
DATE_EN2=`date '+%d-%b-%Y (%a)' --date="$DATE"` || exit 1
TITLE_JA="`grep '^#title_ja:' "$FILE" | tail -1 | sed -e 's/^#title_ja://g'`"
TITLE_EN="`grep '^#title_en:' "$FILE" | tail -1 | sed -e 's/^#title_en://g'`"
SUBTITLE_JA="`grep '^#subtitle_ja:' "$FILE" | tail -1 | sed -e 's/^#subtitle_ja://g'`"
SUBTITLE_EN="`grep '^#subtitle_en:' "$FILE" | tail -1 | sed -e 's/^#subtitle_en://g'`"

echo "<!-- BEGIN NEWS $DATE -->"
echo "  <div class='panel panel-default'>"
echo "    <div class='panel-heading' style='padding-left: 5%; padding-right: 5%'>"
echo "      <h4 class='panel-title'>"
echo "        <a class='accordion-toggle' data-toggle='collapse' data-parent='#accordion' href='#news${DATE}'>"
echo "  <span lang='ja'>($DATE_JA) $TITLE_JA</span>"
echo "  <span lang='en'>($DATE_EN) $TITLE_EN</span>"
echo "        </a>"
echo "      </h4>"
echo "    </div>"
echo "    <div id='news${DATE}' class='panel-collapse collapse${PANEL_STATE}'>"
echo "      <div class='panel-body' style='padding-left: 5%; padding-right: 5%'>"
echo "        <p>"
echo "        <h3 class='text-center'>"
echo "<span lang='ja'>$TITLE_JA</span>"
echo "<span lang='en'>$TITLE_EN</span>"
echo "        </h3>"
if [ -n "$SUBTITLE_JA" -o -n "$SUBTITLE_EN" ]; then
echo "        <h4 class='text-center'>"
echo "<span lang='ja'>〜${SUBTITLE_JA}〜</span>"
echo "<span lang='en'>- ${SUBTITLE_EN} -</span>"
echo "        </h4>"
fi
echo "        </p>"
echo "        <p class='text-right'>"
echo "<strong lang='ja'>$DATE_JA2</strong>"
echo "<strong lang='en'>$DATE_EN2</strong>"
echo "        </p>"
echo "        <!-- Social Plug-in -->"
echo "        <p class='text-right'>"
echo "<span lang='ja'><a href='https://twitter.com/share' class='twitter-share-button' data-url='http://heterodb.com/about.html#news${DATE}' data-text='- HeteroDB,Inc ($DATE_JA) $TITLE_JA'>Tweet</a></span>"
echo "<span lang='en'><a href='https://twitter.com/share' class='twitter-share-button' data-url='http://heterodb.com/about.html#news${DATE}' data-text='- HeteroDB,Inc ($DATE_EN) $TITLE_EN'>Tweet</a></span>"
echo "<iframe src='https://www.facebook.com/plugins/like.php?href=http%3A%2F%2Fheterodb.com%2Fabout.html%23news${DATE}&width=82&layout=button_count&action=like&size=small&show_faces=false&share=false&height=21&appId=231051110746798' width='82' height='21' style='border:none;overflow:hidden' scrolling='no' frameborder='0' allowTransparency='true'></iframe>"
echo "        </p>"
echo "        <div>"
awk '/^#[a-zA-Z_]+:/ {next} {print}' < "$FILE"
echo "        </div>"
echo "      </div>"
echo "    </div>"
echo "  </div>"
echo "<!-- END NEWS $DATE -->"
shift
PANEL_STATE=''
done
