<#import "/header.ftl" as h>
<@h.header>
  <div class="container center-block" style="margin-top: 100px">
    <div class="row justify-content-center align-items-center">
      <h1> Welcome to websocket private chat</h1>
    </div>
    <div class="row justify-content-center align-items-center">
      <form method="post">
      <input type="text" name="username" placeholder="Enter your username">
      <#if username??>
        <button type="submit" value="${username}" name="button">Enter and start chat</button>
      <#else>
        <button type="submit" name="button">Enter and start chat</button>
      </#if>
      <#if error??>
        <div class="alert alert-danger" role="alert" style="margin-top: 20px">
          ${error}
        </div>
      </#if>
    </div>
  </div>
</form>
</@h.header>
