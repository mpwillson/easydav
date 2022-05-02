<?xml version="1.0" encoding="utf-8" ?>
<D:multistatus xmlns:D="DAV:">
    % for real_url, propstats in result_files:
    <D:response>
        <D:href>${real_url}</D:href>
        % for status, props in propstats.items():
        <D:propstat>
            <D:prop>
            % for prop, value in props:
            <%
                prop = prop.replace('{DAV:}','D:')
                import re
                xmlns=re.compile(r'{(.*?)}(.*)')
                prop = xmlns.sub(r'\2 xmlns="\1"',prop)
            %>
            % if value:
                 <${prop}>${value}</${prop}>
            % else:
                <${prop} />
            % endif
            % endfor
            </D:prop>
            <D:status>HTTP/1.1 ${status}</D:status>
            % if hasattr(status,'body'):
                <D:error>${status.body}</D:error>
            % endif
        </D:propstat>
        % endfor
    </D:response>
    % endfor
</D:multistatus>
