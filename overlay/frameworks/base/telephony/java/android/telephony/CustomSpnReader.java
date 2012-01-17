/*
 * LP add to specical for the SPN from the file : /system/etc/spn-conf.xml
 * 
 */
package com.android.internal.telephony;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import android.os.Environment;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import android.content.Context;
import java.io.InputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import android.util.Log;
import java.util.Locale;

public class CustomSpnReader{
		
	private static final String PARTNER_SPN_PATH = "etc/spn-conf.xml";
	private static final String TAG = "CustomSpnReader";
	
	public static String GetCustomName(String operatorNumberic,String oriSpnName){
		
		Log.i(TAG,"operatorNumberic = " + operatorNumberic);
		Log.i(TAG,"oriSpnName = " + oriSpnName);
		if(operatorNumberic == null || oriSpnName == null){
			return oriSpnName;
		}
		
		String customSpnName = oriSpnName;
		
		DocumentBuilderFactory docBuilderFactory = null;
		DocumentBuilder docBuilder = null;
		Document doc = null;
		File confFile = new File(Environment.getRootDirectory(), PARTNER_SPN_PATH);
		Node spnNode = null;
		String locale = Locale.getDefault().getLanguage();
		Log.i(TAG,"Current language is : " + locale);

		Log.e(TAG, "Config File Path : " + confFile.getAbsolutePath());
		try {
			
			docBuilderFactory = DocumentBuilderFactory.newInstance();
			docBuilder = docBuilderFactory.newDocumentBuilder();
			doc = docBuilder.parse(confFile);
			XPath xpath = XPathFactory.newInstance().newXPath();
			
			String expression = "/spnOverrides/spnOverride[@numeric='" + operatorNumberic + "']";
			Log.i(TAG,"expression : " + expression);
			Element spnElement = (Element)xpath.evaluate(expression, doc, XPathConstants.NODE);
			if(spnElement != null) {
				if(spnElement.hasAttribute("spn")) {
					customSpnName = spnElement.getAttribute("spn");
					Log.i(TAG,"got customSpnName : " + customSpnName);
				}else {
					expression = "/spnOverrides/spnOverride[@numeric='" + 
							operatorNumberic + "']/spn[@locale='" + locale + "']";
					Log.i(TAG,"expression : " + expression);
					spnElement = (Element)xpath.evaluate(expression, doc, XPathConstants.NODE);
					if(spnElement != null) {
						customSpnName = spnElement.getTextContent();
						Log.i(TAG,"got customSpnName from the locale : " + customSpnName);
					}
				}
			}else {
				Log.e(TAG,"Not Found : " + operatorNumberic + " in spn-conf.xml");
			}
			
		}catch (IOException e) {
			Log.e(TAG, "Exception while parsing '" + confFile.getAbsolutePath() + "'", e);
			
		}catch (SAXException e) {
			Log.e(TAG, "Exception while parsing '" + confFile.getAbsolutePath() + "'", e);
		}catch (XPathExpressionException e) {
			Log.e(TAG, "Exception while parsing '" + confFile.getAbsolutePath() + "'", e);
		}catch (ParserConfigurationException e) {
			Log.e(TAG, "Exception while parsing '" + confFile.getAbsolutePath() + "'", e);
			
		} finally {
						
			doc = null;
			docBuilder = null;
			docBuilderFactory = null;
		}
		
		
		return customSpnName;
	}
}
/*
// parse the XML as a W3C Document
DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
builderFactory.setNamespaceAware(true);
DocumentBuilder builder = builderFactory.newDocumentBuilder();
Document document = builder.parse(new File("/widgets.xml"));

XPath xpath = XPathFactory.newInstance().newXPath();
String expression = "/widgets/widget";
Node widgetNode = (Node) xpath.evaluate(expression, document, XPathConstants.NODE);
*/

/*
 * 
  <spnOverrides>
  <!-- Japan -->
  <spnOverride numeric="44020" spn="SoftBank" />
  <!-- Hong Kong -->
  <spnOverride numeric="45406" spn="SmarTone" />
  <spnOverride numeric="45412">
    <spn locale="zh">中國移動香港</spn>
    <spn locale="zh_CN">中国移动香港</spn>
  </spnOverride>
  <!-- China -->
  <spnOverride numeric="46000">
    <spn locale="zh">中国移动</spn>
  </spnOverride>
  <spnOverride numeric="46001">
    <spn locale="zh">中国联通</spn>
  </spnOverride>
  <spnOverride numeric="46002">
    <spn locale="zh">中国移动</spn>
  </spnOverride>
  <spnOverride numeric="46003">
    <spn locale="zh">中国电信</spn>
  </spnOverride>
  <spnOverride numeric="46007">
    <spn locale="zh">中国移动</spn>
  </spnOverride>
  <!-- Taiwan -->
  <spnOverride numeric="46601">
    <spn locale="zh">遠傳電信</spn>
  </spnOverride>
  <spnOverride numeric="46688">
    <spn locale="zh">和信電訊</spn>
  </spnOverride>
  <spnOverride numeric="46689">
    <spn locale="zh">威寶電信</spn>
  </spnOverride>
  <spnOverride numeric="46692">
    <spn locale="zh">中華電信</spn>
  </spnOverride>
  <spnOverride numeric="46693">
    <spn locale="zh">東信電訊</spn>
  </spnOverride>
  <spnOverride numeric="46697">
    <spn locale="zh">台灣大哥大</spn>
  </spnOverride>
  <spnOverride numeric="46699">
    <spn locale="zh">泛亞電信</spn>
  </spnOverride>
</spnOverrides>
 */
