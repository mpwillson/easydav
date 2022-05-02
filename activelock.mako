<?xml version="1.0" encoding="utf-8" ?>
<%
import urllib.parse
%>
<D:prop xmlns:D="DAV:">
    <D:lockdiscovery>
        <D:activelock >
            <D:locktype><D:write/></D:locktype>
            <D:lockscope>
              % if lock.shared:
              <D:shared />
              % else:
              <D:exclusive />
              % endif
            </D:lockscope>
            % if lock.infinite_depth:
            <D:depth>infinity</D:depth>
            % else:
            <D:depth>0</D:depth>
            % endif
            <D:owner>${XML(lock.owner)}</D:owner>
            <D:timeout>Second-${str(lock.seconds_until_timeout())}</D:timeout>
            <D:locktoken>
                <D:href>${lock.urn}</D:href>
            </D:locktoken>
            <D:lockroot>
                <D:href>${urllib.parse.urljoin(reqinfo.root_url, lock.path)}</D:href>
            </D:lockroot>
        </D:activelock>
    </D:lockdiscovery>
</D:prop>
