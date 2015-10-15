vdpol <- function (t, y, mu) {
    list(c(
        y[2],
        mu * (1 - y[1]^2) * y[2] - y[1]
    ))
}
