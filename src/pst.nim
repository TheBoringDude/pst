import std/[httpclient, json, parseopt, options]

## SOME VARIABLES
const API = "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url="
const userAgent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/88.0.4324.202 Safari/537.36"

# TYPE RESULTS FOR BETTER PARSING
type
  ChromeUserExperience = object
    FIRST_CONTENTFUL_PAINT_MS: metrics
    FIRST_INPUT_DELAY_MS: metrics

  metrics = object
    percentile: int
    # TODO: distributions
    category: string

  LightHouseResult = object
    `first-contentful-paint`: audits
    `speed-index`: audits
    `interactive`: audits
    `first-meaningful-paint`: audits
    `first-cpu-idle`: audits
    `estimated-input-latency`: audits

  audits = object
    id: string
    title: string
    description: string
    # TODO: [I'm unsure about it's type] score: 
    scoreDisplayMode: string
    displayValue: string
    explanation: Option[string]
    errorMessage: Option[string]
    # TODO: warnings, details [unsure about them]



proc requestWebsite(url: string): string =
  ## requestWebsite retrieves the response from the api request
  
  var client = newHttpClient(userAgent=userAgent)

  result = client.getContent(APi&url)
  # try:
  #   var client = newHttpClient(userAgent=userAgent)

  #   result = client.getContent(APi&url)
  # except HttpRequestError:
  #   echo "There was a problem, try again later"
  #   quit(1)



proc start(website: string) =
  echo "requesting...\n"

  # get website request
  let request = requestWebsite(website)

  # parse response
  let resp = parseJson(request)

  let chr = to(resp["loadingExperience"]["metrics"], ChromeUserExperience)
  let lhr = to(resp["lighthouseResult"]["audits"], LightHouseResult)

  
  # print outputs
  echo "Website: ", website, "\n"

  # chrome user experience
  echo "--Chrome User Experience--\n"
  echo "First Contentful Paint: "
  echo "\t>> ", chr.FIRST_CONTENTFUL_PAINT_MS.category
  echo "First Input Delay: "
  echo "\t>> ", chr.FIRST_INPUT_DELAY_MS.category

  echo "\n"

  # lighthouse output
  echo "--Lighthouse Results--\n"
  echo "First Contentful Paint"
  echo "\t>> ", lhr.`first-contentful-paint`.displayValue
  echo "Speed Index"
  echo "\t>> ", lhr.`speed-index`.displayValue
  echo "Time To Interactive"
  echo "\t>> ", lhr.`interactive`.displayValue
  echo "First Meaningful Paint"
  echo "\t>> ", lhr.`first-meaningful-paint`.displayValue
  echo "First CPU Idle"
  echo "\t>> ", lhr.`first-cpu-idle`.displayValue
  echo "Estimated Input Latency"
  echo "\t>> ", lhr.`estimated-input-latency`.displayValue


proc main() =
  for kind, key, val in getopt():
    case kind
    of cmdArgument: start(key)
    of cmdEnd: break
    of cmdLongOption, cmdShortOption: continue

when isMainModule:
  main()
