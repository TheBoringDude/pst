# pst
Simple CLI utility to check for a website's performance using Google's PageSpeed Insights

## Usage `pst [website]`
```
pst https://developers.google.com
```

### Sample Output
```
requesting...

Website: https://developers.google.com

--Chrome User Experience--

First Contentful Paint: 
        >> AVERAGE
First Input Delay: 
        >> FAST


--Lighthouse Results--

First Contentful Paint
        >> 0.9 s
Speed Index
        >> 1.4 s
Time To Interactive
        >> 0.9 s
First Meaningful Paint
        >> 0.9 s
First CPU Idle
        >> 0.9 s
Estimated Input Latency
        >> 10 ms
```

&copy; TheBoringDude